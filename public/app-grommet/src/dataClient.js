/* eslint-disable */
import { fetchUtils } from 'grommet-on-rest';
import { stringify } from 'query-string';
import {
    GET_LIST,
    GET_ONE,
    GET_MANY,
    GET_MANY_REFERENCE,
    CREATE,
    UPDATE,
    DELETE,
    GET_MORE,
} from 'grommet-on-rest/lib/rest/types';
import {SORT_ASC} from 'grommet-on-rest/lib/reducer/admin/resource/list/queryReducer';
import {snakeCase} from 'lodash';

export default (apiUrl, httpClient = fetchUtils.fetchJson) => {
    /**
     * @param {String} type One of the constants appearing at the top if this file, e.g. 'UPDATE'
     * @param {String} resource Name of the resource to fetch, e.g. 'posts'
     * @param {Object} params The REST request params, depending on the type
     * @returns {Object} { url, options } The HTTP request parameters
     */
    const convertRESTRequestToHTTP = (type, resource, params) => {
        let url = '';
        const options = {};
        switch (type) {
        case GET_MORE:
        case GET_MANY_REFERENCE:
        case GET_LIST:
            const { page, perPage } = params.pagination;
            const { field, order } = params.sort;
            const { name, value } = params.filter;
            var query = {
                'page[offset]': (page - 1) * perPage,
                'page[limit]': perPage, 
            };
            Object.keys(params.filter).forEach(key =>{
                var filterField = 'filter[' + snakeCase(key) +']';
                query[filterField] = params.filter[key];
            })
            if (type === GET_MANY_REFERENCE){
                const targetFilter = 'filter[' + snakeCase(params.target) + ']';
                query[targetFilter] = params.id;
            }
            if (order === SORT_ASC){
                query.sort = field;
            }else{
                query.sort = '-' + field;
            }
            url = `${apiUrl}/${resource}?${stringify(query)}`;
            break;
        case GET_ONE:
            url = `${apiUrl}/${resource}/${params.id}`;
            break;
        case GET_MANY:    
            const query = {'filter[ids]': params.ids.toString() };
            url = `${apiUrl}/${resource}?${stringify(query)}`;
            break;
        case UPDATE:
            url = `${apiUrl}/${resource}/${params.id}`;
            options.method = 'PATCH';
            var attrs = {};
            Object.keys(params.data).forEach(key => attrs[key] = params.data[key]);
            delete attrs['id'];
            const updateParams = {data:{type: resource, id: params.id, attributes: attrs}};         
            options.body = JSON.stringify(updateParams);
            break;
        case CREATE:
            url = `${apiUrl}/${resource}`;
            options.method = 'POST';
            const createParams = {data: {type: resource, attributes: params.data }};
            options.body = JSON.stringify(createParams);
            break;
        case DELETE:
            url = `${apiUrl}/${resource}/${params.id}`;
            options.method = 'DELETE';
            break;
        default:
            throw new Error(`Unsupported fetch action type ${type}`);
        }
        return { url, options };
    };

    /**
     * @param {Object} response HTTP response from fetch()
     * @param {String} type One of the constants appearing at the top if this file, e.g. 'UPDATE'
     * @param {String} resource Name of the resource to fetch, e.g. 'posts'
     * @param {Object} params The REST request params, depending on the type
     * @returns {Object} REST response
     */
    const convertHTTPResponseToREST = (response, type, resource, params) => {
        const { headers, json } = response;
        switch (type) {
        case GET_MORE:
        case GET_MANY_REFERENCE:
        case GET_LIST:
            var jsonData = json.data.map(function (dic) {
                var interDic = Object.assign({ id: dic.id }, dic.attributes, dic.meta);
                if (dic.relationships){
                    Object.keys(dic.relationships).forEach(function(key){
                        var keyString = key + '_id';
                        if (dic.relationships[key].data){
                            //if relationships have a data field --> assume id in data field
                            interDic[keyString] = dic.relationships[key].data.id;
                        }else if (dic.relationships[key].links){
                            //if relationships have a link field
                            var link = dic.relationships[key].links['self'];
                            httpClient(link).then(function (response) {
                                interDic[key] = {'data': response.json.data, 'count': response.json.data.length};
                                interDic['count'] = response.json.data.length;
                            });
                        }
                    })
                }
                return interDic;
            });
            if (json.meta['record-count']===undefined || json.meta['record-total']===undefined) {
                throw new Error(
                    'The Record-Count or Record-Total is missing in the meta of the HTTP Response. The JSONAPI REST client expects responses for lists of resources to contain this meta with the total number of results to build the pagination.'
                );
            }            
            return { data: jsonData, total: json.meta['record-count'], count: json.meta['record-total'] };
        case GET_MANY:
                jsonData = json.data.map(function(obj){
                    return Object.assign({id: obj.id}, obj.attributes);
                })
                return {data: jsonData}
        case UPDATE:
        case CREATE:
            return { data: Object.assign({id: json.data.id}, json.data.attributes) };
        case DELETE:
            return {data: json}
        case GET_ONE:
            return {data: Object.assign({id: json.data.id}, json.data.attributes)}            
        default:
            return {data:json.data};
        }
    };

    /**
     * @param {string} type Request type, e.g GET_LIST
     * @param {string} resource Resource name, e.g. "posts"
     * @param {Object} payload Request parameters. Depends on the request type
     * @returns {Promise} the Promise for a REST response
     */
    return (type, resource, params) => {
        const { url, options } = convertRESTRequestToHTTP(type, resource, params);
        return httpClient(url, options)
            .then(response => convertHTTPResponseToREST(response, type, resource, params));
    };
};


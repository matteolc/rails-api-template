import React from 'react';
import {Admin, Resource, fetchUtils} from 'grommet-on-rest';
import jsonAPIRestClient from './jsonApiRestClient';
import { 
  PostList, 
  PostEdit, 
  PostShow,  
  PostCreate,  
  AuthorList, 
  AuthorEdit,
  AuthorShow,
  AuthorCreate,
  AccountShow,
  AccountEdit,
  UserList,
  UserShow,
  UserCreate,
  UserEdit,  
} from './resources';
import { Delete  } from 'grommet-on-rest/lib/grommet';
import authClient, {setRequestSessionHeaders} from './authClient';
import { ROLE_ADMIN } from 'grommet-on-rest';
import './App.css';
export const baseApiUrl = `${process.env.REACT_APP_API_PROTOCOL}://${process.env.REACT_APP_API_ADDRESS}:${process.env.REACT_APP_API_PORT}/api/v1`

const httpClient = (url, options = {}) => {
  if (!options.headers) {
    options.headers = new Headers({Accept: 'application/vnd.api+json'});
    options.headers.set('Content-Type', 'application/vnd.api+json')
  }
  setRequestSessionHeaders(options.headers);
  return fetchUtils.fetchJson(url, options);
}

export const apiClient = jsonAPIRestClient(baseApiUrl, httpClient);

const App = () => (
  <Admin
    theme='neutral-3'
    title={process.env.REACT_APP_NAME}
    authClient={authClient}    
    restClient={apiClient}> 
    {permissions => [
      <Resource
        name="authors"
        list={AuthorList}
        show={AuthorShow}
        edit={AuthorEdit}
        create={AuthorCreate}
        remove={Delete}/>,
      <Resource
        name="posts"
        list={PostList}
        show={PostShow}
        edit={PostEdit}
        create={PostCreate}
        remove={Delete}/>,     
      permissions === ROLE_ADMIN && <Resource 
        name="users" 
        list={UserList} 
        show={UserShow} 
        remove={Delete} 
        edit={UserEdit} 
        icon={UserIcon}
        create={UserCreate}/>,
      <Resource 
        name="accounts" 
        edit={AccountEdit}
        show={AccountShow}/>
    ]}               
    </Admin>
  );
  
  export default App;
  
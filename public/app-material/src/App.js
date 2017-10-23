import React from 'react';
import {Admin, Resource, fetchUtils} from 'admin-on-rest';
import jsonAPIRestClient from './dataClient';
import { 
  AccountShow,
  AccountEdit,
  UserList,
  UserShow,
  UserCreate,
  UserEdit,
  UserIcon,  
  AuthorList, 
  AuthorEdit,
  AuthorShow,
  AuthorCreate,
  AuthorIcon,
  PostList, 
  PostEdit, 
  PostShow,  
  PostCreate,     
  PostIcon,
} from './resources';
import { Delete  } from 'admin-on-rest/lib/mui';
import authClient, {setRequestSessionHeaders} from './authClient';
import { ROLE_ADMIN } from './types';
import theme from './theme';
import Menu from './components/Menu';
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
    theme={theme}
    title={process.env.REACT_APP_NAME}
    authClient={authClient}
    menu={Menu}
    restClient={apiClient}> 
    {permissions => [  
      permissions === ROLE_ADMIN && <Resource 
        name="users" 
        list={UserList} 
        show={UserShow} 
        remove={Delete} 
        edit={UserEdit} 
        icon={UserIcon}
        create={UserCreate}/>,
      <Resource
        name="authors"
        icon={AuthorIcon}
        list={AuthorList}
        show={AuthorShow}
        edit={AuthorEdit}
        create={AuthorCreate}
        remove={Delete}/>,    
      <Resource
        name="posts"
        icon={PostIcon}
        list={PostList}
        show={PostShow}
        edit={PostEdit}
        create={PostCreate}
        remove={Delete}/>,               
      <Resource 
        name="accounts" 
        edit={AccountEdit}
        show={AccountShow}/>
    ]}               
    </Admin>
  );
  
  export default App;
  

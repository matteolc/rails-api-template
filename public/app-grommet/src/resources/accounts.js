import React from 'react';
import {
    TextField,
    TextInput,
    Show,
    SimpleShowLayout,
    Edit,
    SimpleForm,
    PasswordInput,
} from 'grommet-on-rest/lib/grommet';

const AccountTitle = ({ record }) => {
    return <span>{record ? `${record.username}` : ''}</span>;
};

export const AccountShow = (props) => (
    <Show
      {...props}
      title={<AccountTitle />} 
    >
      <SimpleShowLayout>  
          <TextField source="username" />
          <TextField source="email" type="email"/>   
      </SimpleShowLayout>      
    </Show>
  );

export const AccountEdit = (props) => (
  <Edit
    {...props}
    title={<AccountTitle />} 
  >
    <SimpleForm>  
        <TextInput source="username" />
        <TextInput source="email" type="email"/>   
        <PasswordInput source="password" type="password"/>
        <PasswordInput source="password_confirmation" type="password"/>
    </SimpleForm>      
  </Edit>
);
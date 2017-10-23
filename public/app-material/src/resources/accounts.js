import React from 'react';
import {
    List,
    TextField,
    DateField,
    SimpleList,
    Filter,
    TextInput,
    NumberInput,
    BooleanInput,
    DateInput,
    Show,
    SimpleShowLayout,
    Edit,
    SimpleForm,
    SelectInput,
    PasswordInput,
    TabbedForm,
    FormTab,
    Create,
    ReferenceInput,
    TabbedShowLayout,
    Tab,
    ReferenceManyField,
    SingleFieldList,
} from 'admin-on-rest/lib/mui';
import MuiAccountIcon from 'material-ui/svg-icons/action/account-box';
export {MuiAccountIcon as AccountIcon};

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
    <SimpleForm redirect={false}>  
        <TextInput source="username" />
        <TextInput source="email" type="email"/>   
        <TextInput source="password" type="password"/>
        <TextInput source="password_confirmation" type="password"/>
    </SimpleForm>      
  </Edit>
);
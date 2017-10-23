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
    ReferenceField,
    BooleanField,
    MeterField,
    ValueField,
    CheckboxGroupInput,
    MultiChipField,
} from 'grommet-on-rest/lib/grommet';
import { ROLE_ADMIN, ROLE_REGULAR, ROLE_GUEST } from 'grommet-on-rest';
import {capitalize} from 'lodash';

const Filters = (props) => (
    <Filter {...props}>
        <TextInput source="email"/>
    </Filter>
);

export const userRoles = [ROLE_ADMIN, ROLE_REGULAR, ROLE_GUEST].map(role => { return {id: role, name: capitalize(role)} });

const UserTitle = ({record}) => record
    ? <span>{record.username}</span>
    : null;

export const UserList = (props) => (
    <List
        title="Users"
        sort={{
        field: 'username',
        order: 'asc'
    }}
        {...props}
        filters={< Filters />}
        sortable={['id', 'username']}>

        <SimpleList 
            primaryText={record => record.username}
            secondaryText={record => record.email}
            tertiaryText={record => record['created-at']}
        />
    </List>
);

export const UserShow = (props) => (
    <Show {...props} title={< UserTitle />}>
        <SimpleShowLayout>
            <TextField source="username"/>
            <TextField source="email"/>
            <TextField source="username"/>
            <MultiChipField source="roles" label="Roles" choices={userRoles} />
        </SimpleShowLayout>
    </Show>
);

const validateUserEdit = (values) => {
    const errors = {};
    ['username'].map((requiredField) => {
        if (!values[requiredField]) {
            errors[requiredField] = ['This field is required'];
        }
    })
    return errors
};

export const UserEdit = (props) => (
    <Edit {...props} title="Edit User">
        <SimpleForm validate={validateUserEdit}>
            <TextInput source="username"/>
            <TextInput source="email" type="email"/>
            <CheckboxGroupInput source="roles" label="Roles" choices={userRoles} />
        </SimpleForm>
    </Edit>
);

export const UserCreate = (props) => (
    <Create {...props} title="Create User">
        <SimpleForm defaultValue={{roles: ['regular']}} redirect={'show'} validate={validateUserEdit}>
            <TextInput source="username"/>
            <TextInput source="email" type="email"/>
            <PasswordInput source="password" type="password"/>        
            <CheckboxGroupInput source="roles" label="Roles" choices={userRoles} />
        </SimpleForm>
    </Create>
);
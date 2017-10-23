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
    SingleFieldList
} from 'grommet-on-rest/lib/grommet';

const Filters = (props) => (
    <Filter {...props}>
        <TextInput source="name" alwaysOn/>
    </Filter>
);

export const AuthorList = (props) => (
    <List
        sort={{
        field: 'name',
        order: 'asc'
    }}
        title="Authors"
        {...props}
        filters={< Filters />}
        sortable={['name']}>
        <SimpleList
            primaryText={record => record.name}
            secondaryText={record => record.id}
            tertiaryText={record => record['created-at']}/>
    </List>
);

const AuthorTitle = ({record}) => record
    ? <span>{record.name}</span>
    : null;

export const AuthorShow = (props) => (
    <Show {...props} title={< AuthorTitle />}>
        <SimpleShowLayout>
            <ReferenceManyField label="Posts" target="author-id" reference="posts">
                <SingleFieldList>
                    <TextField source="title"/>
                </SingleFieldList>
            </ReferenceManyField>

            <TextField source="name"/>
        </SimpleShowLayout>
    </Show>
);

export const AuthorEdit = (props) => (
    <Edit {...props} title={< AuthorTitle />}>
        <SimpleForm redirect={false}>
            <TextInput source="name"/>
        </SimpleForm>
    </Edit>
);

export const AuthorCreate = (props) => (
    <Create {...props}>
        <SimpleForm redirect={'show'}>
            <TextInput source="name"/>
        </SimpleForm>
    </Create>
);
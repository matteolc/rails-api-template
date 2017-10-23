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
    ValueField
} from 'grommet-on-rest/lib/grommet';
import LikeIcon from 'grommet/components/icons/base/Like';

const Filters = (props) => (
    <Filter {...props}>
        <TextInput source="title"/>
    </Filter>
);

const PostTitle = ({record}) => record
    ? <span>{record.title}</span>
    : null;

export const PostList = (props) => (
    <List
        title="Posts"
        sort={{
        field: 'title',
        order: 'asc'
    }}
        {...props}
        filters={< Filters />}
        sortable={['id', 'title']}>

        <SimpleList
            primaryText={record => record.title}
            secondaryText={record => record.body}
            tertiaryText={record => record['created-at']}/>
    </List>
);

export const PostShow = (props) => (
    <Show {...props} title={< PostTitle />}>
        <TabbedShowLayout>
            <Tab label="General">
                <ReferenceField label="Author" source="author-id" reference="authors">
                    <TextField source="name"/>
                </ReferenceField>
                <TextField source="title"/>
                <MeterField source="likes"/>
                <ValueField
                    source="likes"
                    label="Likes"
                    options={{
                    reverse: true,
                    icon: <LikeIcon/>
                }}/>
            </Tab>
            <Tab label="Publishing">
                <BooleanField source="published"/>
                <DateField source="published-at"/>
            </Tab>
        </TabbedShowLayout>
    </Show>
);

const validatePostEdit = (values) => {
    const errors = {};
    ['title'].map((requiredField) => {
        if (!values[requiredField]) {
            errors[requiredField] = ['This field is required'];
        }
    })
    return errors
};

const choices = [
    {
        id: 'harry_potter',
        name: 'Harry Potter'
    }, {
        id: 'fantasy',
        name: 'Fantasy'
    }, {
        id: 'horror',
        name: 'Horror'
    }
];

export const PostEdit = (props) => (
    <Edit {...props} title="Edit Post">
        <TabbedForm validate={validatePostEdit}>
            <FormTab label="General">
                <TextInput source="title"/>
                <NumberInput source="likes"/>
                <SelectInput source="category" choices={choices}/>
            </FormTab>
            <FormTab label="Publishing">
                <BooleanInput source="published"/>
                <DateInput source="published-at"/>

            </FormTab>
        </TabbedForm>
    </Edit>
);

export const PostCreate = (props) => (
    <Create {...props} title="Create Post">
        <TabbedForm redirect={'show'} validate={validatePostEdit}>
            <FormTab label="General">
                <ReferenceInput
                    label="Author"
                    source="author-id"
                    reference="authors"
                    allowEmpty>
                    <SelectInput optionText="name"/>
                </ReferenceInput>
                <TextInput source="title"/>
                <NumberInput source="likes"/>
                <SelectInput source="category" choices={choices}/>
            </FormTab>
            <FormTab label="Publishing">
                <BooleanInput source="published"/>
                <DateInput source="published-at"/>

            </FormTab>
        </TabbedForm>
    </Create>
);
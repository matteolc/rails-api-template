import React from 'react';
import {
    Responsive,
    Datagrid,
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
    NumberField,
    EditButton,
} from 'admin-on-rest/lib/mui';
import RichTextInput from 'aor-rich-text-input';
import {WithPermission} from 'admin-on-rest';
import MuiPostIcon from 'material-ui/svg-icons/editor/border-color'; 
export { MuiPostIcon as PostIcon};

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
        filters={< Filters />}>
        {permissions =>
        <Responsive 
        small={
            <SimpleList
                primaryText={record => record.title}
                secondaryText={record => record.body} 
                tertiaryText={record => record['created-at']}                             
            />
        }           
        medium = {    
            <Datagrid>
            <TextField source="title"/>
            <TextField source="body"/>
            <NumberField source="likes" />
            <ReferenceField label="Author" source="author-id" reference="authors">
                <TextField source="name"/>
            </ReferenceField>
            <EditButton style={{
                textAlign: 'right'
            }}/>
        </Datagrid> }
            />
      }     
    </List>
);

export const PostShow = (props) => (
    <Show {...props} title={< PostTitle />}>
        <TabbedShowLayout>
            <Tab  label="General">
            <ReferenceField label="Author" source="author-id" reference="authors">
            <TextField source="name"/>
            </ReferenceField>                
            <TextField source="title"/>
            <NumberField source="likes" />
            </Tab>
            <Tab  label="Publishing">
            <BooleanField source="published" />
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
        { id: 'harry_potter', name: 'Harry Potter' },
        { id: 'fantasy', name: 'Fantasy' },
        { id: 'horror', name: 'Horror' },
];

export const PostEdit = (props) => (
    <Edit {...props} title="Edit Post">
        <TabbedForm validate={validatePostEdit}>
            <FormTab label="General">
            <TextInput source="title"/>
            <ReferenceInput label="Author" source="author-id" reference="authors">
                <SelectInput optionText="name"/>
            </ReferenceInput> 
            <RichTextInput source="body"/>
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
            <ReferenceInput label="Author" source="author-id" reference="authors" allowEmpty>
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
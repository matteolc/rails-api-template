
import React from 'react';
import {SESSION_ACCOUNT_ID} from '../authClient';
import {MenuItemLink} from 'admin-on-rest/lib/mui';
import {AccountIcon} from '../resources';

export default ({ onClick }) => (
    <MenuItemLink
        key="account"
        to={`/accounts/${localStorage.getItem(SESSION_ACCOUNT_ID)}`}
        primaryText="My Account"
        onClick={onClick}
        leftIcon={<AccountIcon />}/>                             
);
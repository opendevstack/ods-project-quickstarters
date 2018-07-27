import React from 'react';
import {ListItem, ListItemIcon, ListItemText} from '@material-ui/core';
import {Star} from '@material-ui/icons';


const Repo = (props) => {
  return (
    <ListItem>
      <ListItemIcon>
        <Star />
      </ListItemIcon>
      <ListItemText>
        <a href={props.html_url} target="_blank" rel="noopener noreferrer">
          {props.name}
        </a>
      </ListItemText>
    </ListItem>
  )
};

export default Repo;

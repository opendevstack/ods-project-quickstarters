import React from 'react';
import { ListItem, ListItemIcon, ListItemText } from '@material-ui/core';
import Star from '@material-ui/icons/Star';
import PropTypes from 'prop-types';

const Repo = (props) => (
  <ListItem>
    <ListItemIcon>
      <Star/>
    </ListItemIcon>
    <ListItemText>
      <a href={props.html_url} target="_blank" rel="noopener noreferrer">
        {props.name}
      </a>
    </ListItemText>
  </ListItem>
);

Repo.propTypes = {
  html_url: PropTypes.string,
  name: PropTypes.string,
};

export default Repo;

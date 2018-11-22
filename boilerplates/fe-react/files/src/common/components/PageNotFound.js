import React from 'react'
import withStyles from "@material-ui/core/styles/withStyles";

export const PageNotFound = withStyles(({ spacing }) => ({
  container: {
    padding: `0 ${spacing.unit * 2}px`,
    fontFamily: '"Roboto", sans-serif !important',
    color: '#4a4a4a',
  },
}))(({ classes }) => (
  <h2 className={classes.container}>
    Page not found!
  </h2>
));

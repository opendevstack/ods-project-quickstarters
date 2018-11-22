import React from 'react'
import withStyles from "@material-ui/core/styles/withStyles";

export const PageNotFound = withStyles(({ spacing, fontFamily, palette }) => ({
  container: {
    padding: `0 ${spacing.unit * 2}px`,
    fontFamily,
    color: palette.common.grey,
  },
}))(({ classes }) => (
  <h2 className={classes.container}>
    Page not found!
  </h2>
));

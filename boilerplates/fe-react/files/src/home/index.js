import React from 'react';
import UserRepos from './containers/UserRepos';
import PropTypes from 'prop-types';
import withStyles from '@material-ui/core/styles/withStyles';

const styles = ({ spacing }) => ({
  container: {
    padding: `0 ${spacing.unit * 2}px`
  },
});

const Home = withStyles(({ spacing }) => ({
  container: {
    padding: `0 ${spacing.unit * 2}px`,
    fontFamily: '"Roboto", sans-serif !important',
    color: '#4a4a4a',
  },
}))(({ classes }) =>
  (<div className={classes.container}>
    <h2 className="text-center">OpenDevStack</h2>
    <UserRepos/>
  </div>));

Home.propTypes = {
  classes: PropTypes.object,
};

export default withStyles(styles)(Home);



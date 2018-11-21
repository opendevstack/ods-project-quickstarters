import React, { Component } from 'react';
import UserRepos from './containers/UserRepos';
import PropTypes from 'prop-types';
import withStyles from '@material-ui/core/styles/withStyles';

const styles = () => ({
  container: {
    padding: '0 20px'
  },
});

class Home extends Component {
  render() {
    const { classes } = this.props;
    return (
      <div id="home">
        <div className={classes.container}>
          <h2 className="text-center">OpenDevStack</h2>
          <UserRepos/>
        </div>
      </div>
    );
  }
}


Home.propTypes = {
  classes: PropTypes.object,
};

export default withStyles(styles)(Home);



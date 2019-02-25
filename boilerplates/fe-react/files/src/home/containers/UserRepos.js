import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import Repo from '../components/Repo';
import { doUserRepos, getUserRepos, isLoading } from '../reducers/applyUserRepos.duck';
import { bindActionCreators } from 'redux';
import List from '@material-ui/core/List';


class UserRepos extends Component {

  componentDidMount() {
    let username = 'BIX-digital-lab';
    this.props.doUserRepos(username);
  }

  render() {
    let { repos, loading } = this.props,
      pageContent = '';

    if(loading) {
      pageContent = (
        <div className="userReposLoader">
          Loading...
        </div>
      )
    } else {
      pageContent = (
        <List>
          {repos.map((repo, i) => <Repo key={i} {...repo} />)}
        </List>
      )
    }

    return (
      <div>
        <h3>Our Github Projects:</h3>
        {pageContent}
      </div>
    );

  }
}

UserRepos.propTypes = {
  repos: PropTypes.array,
  loading: PropTypes.bool,
};

const mapStateToProps = state => {
  return {
    repos: getUserRepos(state),
    loading: isLoading(state)
  };
};

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators({
    doUserRepos
  }, dispatch)
};

export default connect(mapStateToProps, mapDispatchToProps)(UserRepos);

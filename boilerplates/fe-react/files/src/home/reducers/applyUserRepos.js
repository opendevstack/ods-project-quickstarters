import {
  REQUEST_USER_REPOS_FAILED, REQUEST_USER_REPOS_START, REQUEST_USER_REPOS_SUCCESS
} from '../actions/actionTypes';

let initialState = {
  repos: [],
  isLoading: false,
  errors: []
};

function applyUserRepos(state = initialState, action) {

  switch (action.type) {
    case REQUEST_USER_REPOS_START:
      return Object.assign({}, state, {
        isLoading: true
      });

    case REQUEST_USER_REPOS_FAILED:
      return Object.assign({}, state, {
        isLoading: false,
        errors: action.payload
      });

    case REQUEST_USER_REPOS_SUCCESS:
      return Object.assign({}, state, {
        isLoading: false,
        repos: action.payload
      });

    default:
      return state;
  }
}

export default applyUserRepos;

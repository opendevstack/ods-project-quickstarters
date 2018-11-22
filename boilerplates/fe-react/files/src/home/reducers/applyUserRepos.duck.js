export const REQUEST_USER_REPOS_START = 'REQUEST_USER_REPOS_START';
const REQUEST_USER_REPOS_SUCCESS = 'REQUEST_USER_REPOS_SUCCESS';
const REQUEST_USER_REPOS_FAILED = 'REQUEST_USER_REPOS_FAILED';


let initialState = {
  repos: [],
  isLoading: false,
  errors: []
};

export default function (state = initialState, action) {

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
export const doUserRepos = (payload) => ({
  type: REQUEST_USER_REPOS_START,
  payload
});


export const doUserReposFulfilled = (payload) => ({
  type: REQUEST_USER_REPOS_SUCCESS,
  payload
});

// on fail
export const doUserReposFailed = (payload) => ({
  type: REQUEST_USER_REPOS_FAILED,
  payload
});


export const getUserRepos = (state) => (state.home.userRepos.repos);
export const isLoading = (state) => (state.home.userRepos.isLoading);

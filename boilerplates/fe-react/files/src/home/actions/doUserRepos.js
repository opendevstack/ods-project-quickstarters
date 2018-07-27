import { REQUEST_USER_REPOS_FAILED, REQUEST_USER_REPOS_START, REQUEST_USER_REPOS_SUCCESS } from './actionTypes'

// start request
export function doUserRepos(payload) {
  return {
    type: REQUEST_USER_REPOS_START,
    payload
  };
}

// on successful
export function doUserReposFulfilled(payload) {
  return {
    type: REQUEST_USER_REPOS_SUCCESS,
    payload
  };
}

// on fail
export function doUserReposFailed(payload) {
  return {
    type: REQUEST_USER_REPOS_FAILED,
    payload
  };
}

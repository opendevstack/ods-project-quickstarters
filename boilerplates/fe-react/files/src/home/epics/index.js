import { combineEpics } from 'redux-observable';
// import your Home Module epics here and combine them
// Place all epics in same directory
import userRepos from './fetchUserRepos'

const home = combineEpics(
  userRepos
);

export default home

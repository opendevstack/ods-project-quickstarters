import { combineReducers } from 'redux';
// import your Home Module reducers here and combine them
// Placed in same directory
import userRepos from './applyUserRepos'

const home = combineReducers({
  userRepos
});

export default home;

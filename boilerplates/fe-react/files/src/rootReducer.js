import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
// import your Module reducers here and combine them
import home from './home/reducers'

const rootReducer = combineReducers({
  home,
  router: routerReducer
});

export default rootReducer;

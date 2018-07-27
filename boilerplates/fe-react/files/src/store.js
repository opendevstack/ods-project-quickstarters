import { applyMiddleware, createStore } from 'redux';
import { createEpicMiddleware } from 'redux-observable';
import createHistory from 'history/createHashHistory';
import { routerMiddleware } from 'react-router-redux';
// import root epics/reducer
import rootEpic from './rootEpic';
import rootReducer from './rootReducer';
import queryString from 'querystring';

// export `history` to use in index.js, we using `createBrowserHistory`
export const history = createHistory();

const epicMiddleware = createEpicMiddleware(rootEpic, {
  dependencies: {
    queryString
  }
});

// Build the middleware for intercepting and dispatching navigation actions
const appRouterMiddleware = routerMiddleware(history);

const store = createStore(
  rootReducer,
  applyMiddleware(epicMiddleware),
  applyMiddleware(appRouterMiddleware)
);

export default store;

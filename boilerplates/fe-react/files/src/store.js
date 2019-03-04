import { applyMiddleware, createStore, compose } from 'redux';
import { createEpicMiddleware } from 'redux-observable';
import { connectRouter, routerMiddleware } from 'connected-react-router';
import rootEpic from './rootEpic';
import rootReducer from './rootReducer';
import { history } from './history';

const epicMiddleware = createEpicMiddleware();
const store = createStore(
  connectRouter(history)(rootReducer),
  compose(
    applyMiddleware(epicMiddleware),
    applyMiddleware(routerMiddleware(history)),
    process.env.NODE_ENV === 'development' && window.devToolsExtension
      ? window.devToolsExtension()
      : f => f
  )
);

epicMiddleware.run(rootEpic);

export default store;

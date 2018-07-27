import { combineEpics } from 'redux-observable';
// Import epics and combine
import home from './home/epics';

const rootEpic = combineEpics(
  home
);

export default rootEpic

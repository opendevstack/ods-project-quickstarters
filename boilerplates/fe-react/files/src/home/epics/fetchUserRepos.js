import { ajax } from 'rxjs/observable/dom/ajax';
import { ofType } from 'redux-observable';
import { catchError, mergeMap, map } from 'rxjs/operators';

import { REQUEST_USER_REPOS_START } from '../actions/actionTypes';

import { doUserReposFulfilled, doUserReposFailed } from '../actions/doUserRepos';

// Also now using v6 pipe operators
const fetchUserRepos = (action$, state$) =>
  action$.pipe(
    ofType(REQUEST_USER_REPOS_START),
    mergeMap(action => {
      let apiUrl = `https://api.github.com/users/${action.payload}/repos`;
      return ajax
        .getJSON(apiUrl)
        .pipe(
          map(response => doUserReposFulfilled(response)),
          catchError(error => doUserReposFailed(error.xhr.response))
        );
    })
  );

export default fetchUserRepos;

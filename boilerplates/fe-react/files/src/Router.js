import React from 'react';
import { Route, Switch } from 'react-router';
import Home from './home';
import PageNotFound from './common/components/PageNotFound';
import { history } from './history';
import { ConnectedRouter } from 'connected-react-router';
import withStyles from '@material-ui/core/styles/withStyles';


export const Router = withStyles({
  app: {
    height: '100vh',
    width: '100vw',
    fontFamily: '"Roboto", sans-serif !important',
    overflow: 'hidden',
    color: '#4a4a4a',

    display: 'flex',
    justifyContent: 'stretch'
  },
  page: {
    flex: 1
  }
})(({ classes }) => (
  <ConnectedRouter history={history}>
    <div>
      <div className={classes.app}>
        <div className={classes.page}>
          <Switch>
            <Route exact path="/" component={Home} />
            <Route component={PageNotFound} />
          </Switch>
        </div>
      </div>
    </div>
  </ConnectedRouter>
));

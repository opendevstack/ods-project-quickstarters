import React from "react";
import { Provider } from 'react-redux'
import { AppBar, CssBaseline, Toolbar, Typography } from '@material-ui/core';
import MuiThemeProvider from '@material-ui/core/styles/MuiThemeProvider';
import { theme } from './theme';
import { Router } from './Router';

import store from './store';

const App = () => (
  <Provider store={store}>
    <div>
      <MuiThemeProvider theme={theme}>
        <React.Fragment>
          <CssBaseline/>
          <AppBar position="static">
            <Toolbar>
              <Typography variant="title" color="inherit">BI X</Typography>
            </Toolbar>
          </AppBar>
          <Router/>
        </React.Fragment>
      </MuiThemeProvider>
    </div>
  </Provider>
);

export default App;

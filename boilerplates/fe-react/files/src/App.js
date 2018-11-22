import React, { Component } from "react";
import { Provider } from 'react-redux'
import { ConnectedRouter } from 'react-router-redux';
import { AppBar, CssBaseline, Toolbar, Typography } from '@material-ui/core';
import MuiThemeProvider from '@material-ui/core/styles/MuiThemeProvider';
import { theme } from './theme';
import { Router } from './Router';

import store from './store';

class App extends Component {

  render() {
    return (
      <Provider store={store}>
        <div >
          <MuiThemeProvider theme={theme}>
            <div>
              <CssBaseline/>
              <AppBar position="static">
                <Toolbar>
                  <Typography variant="title" color="inherit">BI X</Typography>
                </Toolbar>
              </AppBar>
              <div>
                <Router/>
              </div>
            </div>
          </MuiThemeProvider>
        </div>
      </Provider>
    );
  }
}

export default App;

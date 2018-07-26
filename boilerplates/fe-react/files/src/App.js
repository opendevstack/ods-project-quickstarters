import React, {Component} from "react";
import {Provider} from 'react-redux'
import {ConnectedRouter} from 'react-router-redux';
import {AppBar, createMuiTheme, CssBaseline, MuiThemeProvider, Toolbar, Typography} from '@material-ui/core';

import store, {history} from './store';
import './App.css';
// routes
import routes from './routes';
// common components
import Footer from './common/components/Footer'

// Styles
const theme = createMuiTheme({
  palette: {
    primary: {
      main: '#ad1457',
    },
    secondary: {
      main: '#cddc39',
    },
  },
});


class App extends Component {

  render() {
    return (
      <Provider store={store}>
        <ConnectedRouter history={history}>
          <div className="App">
            <MuiThemeProvider theme={theme}>
              <div className="App">
                <CssBaseline/>
                <AppBar position="static">
                  <Toolbar>
                    <Typography variant="title" color="inherit">Name of the project</Typography>
                  </Toolbar>
                </AppBar>
                <div className="wrap">
                  {routes}
                </div>
              </div>
            </MuiThemeProvider>
            <Footer/>
          </div>
        </ConnectedRouter>

      </Provider>
    );
  }
}

export default App;

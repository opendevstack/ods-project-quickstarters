import createMuiTheme from '@material-ui/core/styles/createMuiTheme';

export const theme = createMuiTheme({
  palette: {
    primary: { main: '#024c4d'},
    secondary: { main: '#cddc39'},
    common: {
      grey: '#4f4f4f'
    }
  },
  fontFamily: 'Roboto, sans-serif',
  spacing: { unit: 8 }
});

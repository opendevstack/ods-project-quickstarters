import createMuiTheme from '@material-ui/core/styles/createMuiTheme';

export const theme = createMuiTheme({
  palette: {
    primary: { main: '#024c4d'},
    secondary: { main: '#cddc39'},
  },
  fontFamily: 'Roboto, sans-serif',
  fontSize: {
    biggest: 32,
    bigger: 20,
    big: 16,
    base: 14,
    small: 12
  },
  bold: 500,
  spacing: { unit: 8 }
});

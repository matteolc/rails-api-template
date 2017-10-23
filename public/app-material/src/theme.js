import {fade} from 'material-ui/utils/colorManipulator';
import spacing from 'material-ui/styles/spacing';

import {
  blueGrey500,
  blueGrey800,
  blue900,
  redA700,
  grey100,
  grey300,
  grey400,
  grey600,
  grey700,
  darkBlack,
  fullBlack,
  white,
  deepOrange500,
} from 'material-ui/styles/colors';

export default {
  spacing : spacing,
  fontFamily : 'Roboto, sans-serif',
  palette : {
    primary1Color: blue900,
    primary2Color: blue900,
    primary3Color: grey400,
    accent1Color: redA700,
    accent2Color: grey100,
    accent3Color: grey700,
    textColor: darkBlack,
    secondaryTextColor: fade(darkBlack, 0.74),
    alternateTextColor: white,
    canvasColor: white,
    borderColor: grey300,
    disabledColor: fade(darkBlack, 0.5),
    pickerHeaderColor: blue900,
    clockCircleColor: fade(darkBlack, 0.07),
    shadowColor: fullBlack
  },
  tabs : {
    backgroundColor: 'white',
    selectedTextColor: blue900,
    textColor: grey600
  },
  inkBar : {
    backgroundColor: blue900
  },
  table : {
    backgroundColor: 'white',
    padding: '0px 24px',
    width: '100%',
    borderCollapse: 'collapse',
    borderSpacing: 0
  },
  tableRow : {
    borderBottom: '1px solid rgb(224, 224, 224)',
    color: 'rgba(0, 0, 0, 0.870588)',
    height: 48
  },
};

import React from 'react'
import { Container } from 'reactstrap';
import './style.css';

class About extends React.Component {

  render() {

    return (
      <div id="about">
        <Container>
          <h2 className="text-center">
            About
          </h2>
          <p>About page content</p>
        </Container>
      </div>
    );
  }

}

export default About;

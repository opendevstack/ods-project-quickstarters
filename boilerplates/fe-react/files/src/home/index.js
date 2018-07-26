import React, { Component } from 'react';
import { Container } from 'reactstrap';
import UserRepos from './containers/UserRepos';
import './style.css';

class Home extends Component {
  render() {
    return (
      <div id="home">
        <Container>
          <h2 className="text-center">BI X Digital Lab</h2>
          <UserRepos/>
        </Container>
      </div>
    );
  }
}

export default Home;

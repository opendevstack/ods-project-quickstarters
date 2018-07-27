import React from 'react';

const AppLoader = ({ isLoading, error }) => {
  let content = '';

  if(isLoading) {
    content = (
      <div className="AppLoader">
        <p>Loading...</p>
      </div>
    );
  } else if(error) {
    content = <div className="AppLoader">Sorry, there was a problem loading the page.</div>;
  }

  return <div className="AppLoader">{content}</div>;
};

export default AppLoader;

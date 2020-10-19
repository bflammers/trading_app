import React from 'react';

const Logo = (props) => {
  return (
    <img
      alt="Logo"
      src="/static/unicorn_logo_small.png"
      {...props}
    />
  );
};

export default Logo;

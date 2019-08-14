// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const Hello = ({name, bye}) => {
  if (bye) {
    return <div>Bye {name}!</div>;
  } else {
    return <div>Hello {name}!</div>;
  }
};

Hello.defaultProps = {
  name: 'David',
  bye: false,
};

Hello.propTypes = {
  name: PropTypes.string,
  bye: PropTypes.bool,
};

document.addEventListener('DOMContentLoaded', () => {
  const elem = document.getElementById('hello-data')
  const bye = elem && elem.dataset.greeting == 'bye'
  ReactDOM.render(
    <Hello name="React" bye={bye} />,
    document.body.appendChild(document.createElement('div')),
  )
});

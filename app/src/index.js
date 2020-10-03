import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter } from 'react-router-dom';
import * as serviceWorker from './serviceWorker';
import App from './App';

import fetchIntercept from 'fetch-intercept';

const fetch_unregister = fetchIntercept.register({
    request: function (url, config) {
        // Modify the url or config here
        const base_url = "http://0.0.0.0:8000/v1/"
        return [base_url + url, config];
    },

    requestError: function (error) {
        // Called when an error occured during another 'request' interceptor call
        return Promise.reject(error);
    },

    response: function (response) {
        // Modify the reponse object
        return response;
    },

    responseError: function (error) {
        // Handle an fetch error
        return Promise.reject(error);
    }
});

ReactDOM.render((
  <BrowserRouter>
    <App />
  </BrowserRouter>
), document.getElementById('root'));

serviceWorker.unregister();

// Unregister your interceptor
fetch_unregister();

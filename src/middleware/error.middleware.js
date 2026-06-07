function notFound(req, res, next) {
  next(Object.assign(new Error('Route not found'), { status: 404 }));
}

function errorHandler(error, req, res, next) {
  const status = error.status || 500;
  const message = status === 500 ? 'Internal server error' : error.message;

  if (status === 500) {
    console.error(error);
  }

  res.status(status).json({
    success: false,
    message
  });
}

module.exports = { notFound, errorHandler };

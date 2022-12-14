
# Divides the array into objects (and the object array is already 
# rendered in the objects). Without this,
# a solid array of data will be rendered
ActiveModelSerializers.config.adapter = :json

Oj.optimize_rails
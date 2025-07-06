valid(String val, int min, int max){
  if(val.isEmpty) {
    return "field cannot be empty";
  }
  if(val.length <min){
    return "must be more than $min";
  }
  if(val.length > max){
    return "must be less than $max";
  }
}
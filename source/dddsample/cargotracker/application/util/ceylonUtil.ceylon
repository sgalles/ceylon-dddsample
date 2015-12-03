shared Result fail<Result>(Exception() e){
	throw e();
}
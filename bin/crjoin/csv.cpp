#include "csv.h"

Operation *Record::context = NULL;

Context::Context() {
  this->datePrefix = "\"";
  this->dateSufix = "\",";
}

void Context::setIdName(string idName) {
  this->idName = idName;
}

void Context::setDatePrefix(string datePrefix) {
  this->datePrefix = datePrefix;
}

void Context::setDateSufix(string dateSufix) {
  this->dateSufix = dateSufix;
}

void Context::setOperation(Operation operation) {
  this->operation = operation;
}

string Context::getIdName() {
  return this->idName;
}

string Context::getDatePrefix() {
  return this->datePrefix;
}

string Context::getDateSufix() {
  return this->dateSufix;
}

Operation Context::getOperation() {
  return this->operation;
}

BaseCustomer::BaseCustomer(string *line) { 
  char delim = '|';
  stringstream ssin(*line);
  string token;
  try {
    getline(ssin, token, delim);
    this->c_custkey = stoi(token);
    getline(ssin, token, delim);
    this->c_name = token;
    getline(ssin, token, delim);
    this->c_address = token;
    getline(ssin, token, delim);
    this->c_nationkey = stoi(token);
    getline(ssin, token, delim);
    this->c_phone = token;
    getline(ssin, token, delim);
    this->c_acctbal = stof(token);
    getline(ssin, token, delim);
    this->c_mktsegment = token;
    getline(ssin, token, delim);
    this->c_comment = token;
  } catch (invalid_argument e) {
    cerr << "Exeption caught at file " << __FILE__ << ", line " << __LINE__ << ":";
    cerr << e.what() << endl;
    throw e;
  }
}

Customer::Customer(string *line) : BaseCustomer(line){}

string Customer::toJson() {
  ostringstream json;
  string idName;
  if (Context::getInstance()->getIdName().empty()) {
    idName = "c_custkey";
  } else {
    idName = Context::getInstance()->getIdName();
  }
  json << "{\"" << idName << "\":" << this->c_custkey << ","
       << "\"c_name\":\"" << this->c_name << "\","
       << "\"c_address\":\"" << this->c_address << "\","
       << "\"c_nationkey\":" << this->c_nationkey << ","
       << "\"c_phone\":\"" << this->c_phone << "\","
       << "\"c_acctbal\":" << this->c_acctbal << ","
       << "\"c_mktsegment\":\"" << this->c_mktsegment << "\","
       << "\"c_comment\":\"" << this->c_comment << "\"}";
  return json.str();
}

CustomerOrder::CustomerOrder(string *line) : BaseCustomer(line){}

CustomerOrder::~CustomerOrder() {
  this->c_orders.clear();
  vector<unique_ptr<OrderLitem>>().swap(this->c_orders);
}

string CustomerOrder::toJson() {
  ostringstream json;
  string idName;
  if (Context::getInstance()->getIdName().empty()) {
    idName = "c_custkey";
  } else {
    idName = Context::getInstance()->getIdName();
  }
  json << "{\"" << idName << "\":" << this->c_custkey << ",";
  json << "\"c_name\":\"" << this->c_name << "\","
       << "\"c_address\":\"" << this->c_address << "\","
       << "\"c_nationkey\":" << this->c_nationkey << ","
       << "\"c_phone\":\"" << this->c_phone << "\","
       << "\"c_acctbal\":" << this->c_acctbal << ","
       << "\"c_mktsegment\":\"" << this->c_mktsegment << "\","
       << "\"c_comment\":\"" << this->c_comment << "\",";
  string orders;
  if (this->c_orders.size() > 0) {
    auto i = begin(this->c_orders);
    orders += (*i)->toJson();
    ++i;
    while (i != end(this->c_orders)) {
      orders += "," + (*i)->toJson();
      ++i;
    }
    json << "\"c_orders\":[" << orders << "]}";
  } else {
    json << "\"c_orders\":[]}";
  }
  return json.str();
}

BaseOrder::BaseOrder(string *line) {
  char delim = '|';
  stringstream ssin(*line);
  string token;
  try {
    getline(ssin, token, delim);
    this->o_orderkey = stoi(token);
    getline(ssin, token, delim);
    this->o_custkey = stoi(token);
    getline(ssin, token, delim);
    this->o_orderstatus = token;
    getline(ssin, token, delim);
    this->o_totalprice = stof(token);
    getline(ssin, token, delim);
    this->o_orderdate = token + "T00:00:00Z";
    getline(ssin, token, delim);
    this->o_orderpriority = token;
    getline(ssin, token, delim);
    this->o_clerk = token;
    getline(ssin, token, delim);
    this->o_shippriority = stoi(token);
    getline(ssin, token, delim);
    this->o_comment = token;  
  } catch (invalid_argument e) {
    cerr << "Exeption caught at file " << __FILE__ << ", line " << __LINE__ << ":";
    cerr << e.what() << endl;
    throw e;
  }
}

Order::Order(string *line) : BaseOrder(line) {}

string Order::toJson() {
  ostringstream json;
  string idName;
  if (Context::getInstance()->getIdName().empty()) {
    idName = "o_orderkey";
  } else {
    idName = Context::getInstance()->getIdName();
  }
  json << "{\"" << idName << "\":" << this->o_orderkey << ","
       << "\"o_custkey\":" << this->o_custkey << ","
       << "\"o_orderstatus\":\"" << this->o_orderstatus << "\","
       << "\"o_totalprice\":" << this->o_totalprice << ","
       << "\"o_orderdate\":{\"$date\":\"" << this->o_orderdate << "\"},"
       << "\"o_orderpriority\":\"" << this->o_orderpriority << "\","
       << "\"o_clerk\":\"" << this->o_clerk << "\","
       << "\"o_shippriority\":" << this->o_shippriority << ","
       << "\"o_comment\":\"" << this->o_comment << "\"}";
  return json.str();
}

OrderLitem::OrderLitem(string *line) : BaseOrder(line) {}

OrderLitem::~OrderLitem() {
  this->o_lineitems.clear();
  vector<unique_ptr<Lineitem>>().swap(this->o_lineitems);
}

string OrderLitem::toJson() {
  ostringstream json;
  string idName;
  if (Context::getInstance()->getIdName().empty()) {
    idName = "o_orderkey";
  } else {
    idName = Context::getInstance()->getIdName();
  }
  Operation operation = Context::getInstance()->getOperation();
  string datePrefix = Context::getInstance()->getDatePrefix();
  string dateSufix = Context::getInstance()->getDateSufix();
  if (operation == CREATE_O_JOIN_L) {
    json << "{\"" << idName << "\":" << this->o_orderkey << ","
	 << "\"o_custkey\":" << this->o_custkey << ",";
  } else {
    json << "{\"o_orderkey\":" << this->o_orderkey << ",";
  }
  json << "\"o_orderstatus\":\"" << this->o_orderstatus << "\","
       << "\"o_totalprice\":" << this->o_totalprice << ","
       << "\"o_orderdate\":" << datePrefix << this->o_orderdate << dateSufix
       << "\"o_orderpriority\":\"" << this->o_orderpriority << "\","
       << "\"o_clerk\":\"" << this->o_clerk << "\","
       << "\"o_shippriority\":" << this->o_shippriority << ","
       << "\"o_comment\":\"" << this->o_comment << "\",";
  string lineitems;
  if (this->o_lineitems.size()  > 0) {
    auto i = begin(this->o_lineitems);
    lineitems += (*i)->toJson();
    ++i;
    while (i != end(this->o_lineitems)) {
      lineitems += "," + (*i)->toJson();
      ++i;
    }
    json << "\"o_lineitems\":[" << lineitems << "]}";
  } else {
    json << "\"o_lineitems\":[]}";
  }
  return json.str();
}

Lineitem::Lineitem(string *line) {
  char delim = '|';
  stringstream ssin(*line);
  string token;
  try {
    getline(ssin, token, delim);
    this->l_orderkey = stoi(token);
    getline(ssin, token, delim);
    this->l_partkey = stoi(token);
    getline(ssin, token, delim);
    this->l_suppkey = stoi(token);
    getline(ssin, token, delim);
    this->l_linenumber = stoi(token);
    getline(ssin, token, delim);
    this->l_quantity = stof(token);
    getline(ssin, token, delim);
    this->l_extendedprice = stof(token);
    getline(ssin, token, delim);
    this->l_discount = stof(token);
    getline(ssin, token, delim);
    this->l_tax = stof(token);
    getline(ssin, token, delim);
    this-> l_returnflag = token;
    getline(ssin, token, delim);
    this-> l_linestatus = token;
    getline(ssin, token, delim);
    this-> l_shipdate = token + "T00:00:00Z";
    getline(ssin, token, delim);
    this-> l_commitdate = token + "T00:00:00Z";
    getline(ssin, token, delim);
    this-> l_receiptdate = token + "T00:00:00Z";
    getline(ssin, token, delim);
    this-> l_shipinstruct = token;
    getline(ssin, token, delim);
    this-> l_shipmode = token;
    getline(ssin, token, delim);
    this-> l_comment = token;
  } catch (invalid_argument e) {
    cerr << "Exeption at line " << __LINE__ << ":";
    cerr << e.what() << endl;
  }
}

string Lineitem::toJson() {
  ostringstream json;
  string idName = Context::getInstance()->getIdName();
  Operation operation = Context::getInstance()->getOperation();
  string datePrefix = Context::getInstance()->getDatePrefix();
  string dateSufix = Context::getInstance()->getDateSufix();
  if (operation == CREATE_SINGLE) {
    json << "{\"" << idName << "\":{\"l_orderkey\":" << this->l_orderkey << ","
	 << "\"l_linenumber\":" << this->l_linenumber << "},";
  } else {
    json << "{\"l_linenumber\":" << this->l_linenumber << ",";
  }
  json << "\"l_partkey\":" << this->l_partkey << ","
       << "\"l_suppkey\":" << this->l_suppkey << ","
       << "\"l_quantity\":" << this->l_quantity << ","
       << "\"l_extendedprice\":" << this->l_extendedprice << ","
       << "\"l_discount\":" << this->l_discount << ","
       << "\"l_tax\":" << this->l_tax << ","
       << "\"l_returnflag\":\"" << this-> l_returnflag << "\","
       << "\"l_linestatus\":\"" << this-> l_linestatus << "\","
       << "\"l_shipdate\":" << datePrefix << this-> l_shipdate << dateSufix
       << "\"l_commitdate\":" << datePrefix << this-> l_commitdate << dateSufix
       << "\"l_receiptdate\":" << datePrefix << this-> l_receiptdate << dateSufix
       << "\"l_shipinstruct\":\"" << this-> l_shipinstruct << "\","
       << "\"l_shipmode\":\"" << this-> l_shipmode << "\","
       << "\"l_comment\":\"" << this-> l_comment << "\"}";
  return json.str();
}

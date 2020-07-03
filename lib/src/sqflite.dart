import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqlite;

import 'output.dart';

class DB {
	String dbName;

	DB({this.dbName});

	Future<dynamic> tryCatch(Future future, {Future onError}) async {
		bool isSucessful = true;
		try{
			return await future;
		} on sqlite.DatabaseException catch(error){
			formatError('[DB]$dbName:DatabaseException error: ', error: error.toString());
			isSucessful = false;
		} 
		catch(error){
			formatError('[DB]$dbName: error: ', error: error.toString());
			isSucessful = false;
		}

		if(onError != null){
			if(!isSucessful) return await onError;
		} else {
			return isSucessful;
		}
	}

	Future<dynamic> _execute(
		Function callback, String sql, [List<dynamic> arguments]) async {
		try{
			return await callback(sql, arguments);
		} catch(e){
			formatError('[DB]', error: e.toString());
		}
	}

	Future<sqlite.Database> _open() async => 
		await sqlite.openDatabase('$dbName.db',);

	Future<int> insertData(String table, Map<String, dynamic> sql) async {
		sqlite.Database _database = await _open();
		int hasInserted = await _database.insert(
			table, sql, conflictAlgorithm: sqlite.ConflictAlgorithm.replace);

		_database.close();
		return hasInserted;
	}

	Future<List<Map<String, dynamic>>> retrieveTable(
		String tableID) async {
		sqlite.Database _database = await _open();
		List<Map<String, dynamic>> data = await _database.query(tableID);
		_database.close();
		return data;
	}

	Future<void> updateData(String table, String id, Map<String, dynamic> sql) async {
		sqlite.Database _database = await _open();
		await _database.update(table, sql, where: "id = ?", whereArgs: [id]);
		_database.close();
	}

	Future<List<Map<String, dynamic>>> retrieveDoc(String table, String id) async {
		sqlite.Database _database = await _open();
		List<Map<String, dynamic>> data = await _database.query(table, where: "id = ?", whereArgs: [id]);
		return data;
	}

	Future<Map<String, dynamic>> retrieveField( String table, String id, String field) async {

		Map<String, dynamic> fieldData = {};
		sqlite.Database _database = await _open();
		List<Map<String, dynamic>> data = await _database.query(table, where: "id = ?", whereArgs: [id]);

		if(data.isNotEmpty){
			Map<String, dynamic> info = data[0];
			fieldData[field] = info[field];
		}

		return fieldData;
	}

	Future<void> deleteData(String table, String id) async {
		sqlite.Database _database = await _open();
		await _database.delete(table, where: "id = ?", whereArgs: [id]);
		_database.close();
	}

	Future<void> createTable(List<String> sql) async {
		for(int index=0; index<sql.length; index++){
			sqlite.Database _database = await _open();
			// await _database.execute(sql[index]);
			await _execute(_database.execute, sql[index]);
			_database.close();
		}
	}

	Future<void> clearTable(List<String> sql, {bool delete=false}) async {

		// String sqlText = 'DROP TABLE IF EXISTS $table';
		// String sqlText = 'DELETE FROM $table';

		for(int index=0; index<sql.length; index++){
			sqlite.Database _database = await _open();

			String sqlText = 'DELETE FROM ${sql[index]}';
			if(delete) sqlText = 'DROP TABLE IF EXISTS ${sql[index]}';
			await _execute(_database.execute, sqlText);
			
			_database.close();
		}
	}
}
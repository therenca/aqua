import 'package:flutter/material.dart';

class Table extends StatefulWidget {

	final List<String> thead;
	final List<List<dynamic>> rows;
	final Function onSelectRaw;
	final Function onSelectAll;

	Table({
		this.thead = const ['TH1', 'TH2', 'TH3', 'TH4'],
		this.rows = const [
			['one', 'two', 'three', 'four'],
			['five', 'six', 'seven', 'eight'],
			['nine', 'ten', 'eleven', 'twelve']
		],
		this.onSelectRaw,
		this.onSelectAll,
	});

	@override
	_TableState createState() => _TableState();

}

class _TableState extends State<Table>{

	List<bool> selectedRowsState;

	@override
	void initState(){
		super.initState();

		selectedRowsState = List<bool>.generate(widget.rows.length, (index) => false);
	}	

	Widget _buildTable(BuildContext context){
		return Container(
			child: ListView(
				children: [
					Row(
						children: [
							Expanded(
								child: Theme(
									data: Theme.of(context).copyWith(
										// toggleableActiveColor: Colors.red,
										// canvasColor: Colors.blue,
										// dataTableTheme: DataTableThemeData(
										// 	dataRowColor: MaterialStateColor.
										// )
										// toggleButtonsTheme: ToggleButtonsThemeData(
										// 	fillColor: Colors.red,
										// 	hoverColor: Colors.red,
										// 	borderColor: Colors.red,
										// 	selectedColor: Colors.blue,
										// )

										colorScheme: ColorScheme.fromSwatch(
											primarySwatch: Colors.deepOrange,
											primaryColorDark: Colors.white,
											accentColor: Colors.blue

										),
										// unselectedWidgetColor: Colors.green,
  										// toggleableActiveColor: Colors.blue,
										// accentColor: Colors.red,
										// primaryColor: Colors.red,
										// toggleButtonsTheme: ToggleButtonsThemeData(
										// 	splashColor: Colors.red
										// ) 										
									),
									child: DataTable(
										showCheckboxColumn: widget.onSelectRaw != null,
										onSelectAll: widget.onSelectAll != null ? widget.onSelectAll : null,
										columnSpacing: 20.0,
										columns: widget.thead.map((th){
											return DataColumn(
												label: Text(
													th,
													style: TextStyle(
														fontSize: 13.0,
														color: Colors.black,
														fontWeight: FontWeight.bold
													),
												)
											);
										}).toList(),
										rows: widget.rows.asMap().entries.map((entry){
											var index = entry.key;
											List row = entry.value; 

											List<DataCell> tdListing = [];
											for(var index=0; index<row.length; index++){
												var td = row[index];
												var tdWidget;
												if(td is String){
													tdWidget = Container(
														child: Text(
															td,
															style: TextStyle(
																fontSize: 12.0,
																color: Colors.black,
																fontWeight: FontWeight.bold,
															),
														),
													);
												} else if(td is Widget){
													tdWidget = td;
												}

												var tdCell = DataCell(
													tdWidget
												);

												tdListing.add(tdCell);
											}

											return DataRow(
												color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
													// All rows will have the same selected color.
													if (states.contains(MaterialState.selected))
														return Theme.of(context).colorScheme.primary.withOpacity(0.08);
													// Even rows will have a grey color.
													if (index % 2 == 0) return Colors.grey.withOpacity(0.3);
													return null; // Use default value for other states and odd rows.
												}),
												selected: selectedRowsState[index],
												onSelectChanged: (bool value){
													if(widget.onSelectRaw != null){
														// var savedValue = selectedRowsState[index];
														// print('index: $index: $savedValue');
														selectedRowsState[index] = value;
														setState((){});
														widget.onSelectRaw(index, value);
													}
												},
												cells: tdListing
											);
										}).toList()
									)
								),
							)
						],
					)
				],
			),
		);
	}

	@override
	Widget build(BuildContext context) => _buildTable(context);

}
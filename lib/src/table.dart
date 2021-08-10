import 'package:flutter/material.dart';

class Table extends StatefulWidget {

	final TextStyle? tdTextStyle;
	final TextStyle? theadTextStyle;
	final List<String> thead;
	final List<List<dynamic>> rows;
	final Function? onSelectRow;
	final Function(bool?)? onSelectAll;
	final List<Map<String, dynamic>>? selectedRows;

	final bool sortAscending;
	final int? sortColumnIndex;

	Table({
		this.thead = const ['TH1', 'TH2', 'TH3', 'TH4'],
		this.rows = const [
			['one', 'two', 'three', 'four'],
			['five', 'six', 'seven', 'eight'],
			['nine', 'ten', 'eleven', 'twelve']
		],
		this.onSelectRow,
		this.onSelectAll,
		this.selectedRows,
		this.theadTextStyle,
		this.tdTextStyle,
		this.sortAscending=false,
		this.sortColumnIndex
	});

	@override
	_TableState createState() => _TableState();

}

class _TableState extends State<Table>{

	bool? _isAscending;
	List<bool>? selectedRowsState;
	List<List<dynamic>>? mutableRows;
	@override
	void initState(){
		super.initState();
		resetState();

	}	

	@override
	void didUpdateWidget(Table oldWidget){
		super.didUpdateWidget(oldWidget);

		resetState();
	}

	void resetState(){
		_isAscending = widget.sortAscending;
		selectedRowsState = List<bool>.generate(widget.rows.length, (index) => false);
		updateSelectedRowsState();

		_isAscending = widget.sortAscending;
		mutableRows = widget.rows;

		setState((){});
	}

	void updateSelectedRowsState(){
		if(widget.selectedRows != null){
			for(var index=0; index<widget.selectedRows!.length; index++){
				var savedState = widget.selectedRows![index];
				var savedIndex = savedState['index'];
				selectedRowsState![savedIndex] = true;

				setState((){});
			}
		}
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
										sortColumnIndex: widget.sortColumnIndex,
										sortAscending: _isAscending!,
										showCheckboxColumn: widget.onSelectRow != null,
										onSelectAll: widget.onSelectAll != null ? widget.onSelectAll : null,
										columnSpacing: 20.0,
										columns: widget.thead.map((th){
											return DataColumn(
												label: Text(
													th,
													style: widget.theadTextStyle == null ? TextStyle(
														fontSize: 13.0,
														color: Colors.black,
														fontWeight: FontWeight.bold
													) : widget.theadTextStyle,
												),
												onSort: (columnIndex, sortAscending){
													if(widget.sortColumnIndex != null){
														if(columnIndex == widget.sortColumnIndex){
															_isAscending = !_isAscending!;
															setState((){});
															if(sortAscending){
																mutableRows!.sort((a, b) => a[widget.sortColumnIndex!].compareTo(b[widget.sortColumnIndex!]));
															} else {
																// mutableRows = mutableRows.reversed.toList();
																mutableRows!.sort((a, b) => b[widget.sortColumnIndex!].compareTo(a[widget.sortColumnIndex!]));
															}
														}
													}
												}
											);
										}).toList(),
										rows: mutableRows!.asMap().entries.map((entry){
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
															style: widget.tdTextStyle == null ?  TextStyle(
																fontSize: 12.0,
																color: Colors.black,
																fontWeight: FontWeight.bold,
															) : widget.tdTextStyle,
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
													return Colors.transparent; // Use default value for other states and odd rows.
												}),
												selected: selectedRowsState![index],
												onSelectChanged: (bool? value){
													if(widget.onSelectRow != null){
														// var savedValue = selectedRowsState[index];
														// print('index: $index: $savedValue');
														selectedRowsState![index] = value!;
														setState((){});
														widget.onSelectRow!(index, value, widget.rows[index]);
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
import 'package:flutter/material.dart';

class CustomTable extends StatefulWidget {

	final String type;
	final Color borderColor;
	final List<String> theader;
	final List<List<dynamic>> tbody;
	final double borderWidth;

	CustomTable({
		@required this.theader,
		@required this.tbody,
		this.type='default',
		this.borderColor=Colors.black,
		this.borderWidth=2.0
	});

	@override
	TableState createState() => TableState();

}

class TableState extends State<CustomTable>{

	Widget _buildTableCell(dynamic td){

		BoxDecoration boxDecoration = BoxDecoration(
			border: Border(
				top: BorderSide(
					width: widget.borderWidth,
					color: widget.borderColor,
				),
				left: BorderSide(
					width: widget.borderWidth,
					color: widget.borderColor
				)
			)
		);

		return TableCell(
			child: Container(
				alignment: Alignment.center,
				decoration: boxDecoration,
				padding: EdgeInsets.all(20.0),
				child: widget.type == 'default' ? Text(
					td,
					style: TextStyle(
						// color: Colors.grey,
						fontSize: 12.0,
						fontWeight: FontWeight.bold
					),
				) : td,
			),
		);
	}

	TableRow _buildTableHeader(){

		List<Widget> tdchildren = [];
		widget.theader.forEach((td){
			Widget tableCell = _buildTableCell(td);

			tdchildren.add(tableCell);
		});

		TableRow tableHeader = TableRow(
			children: tdchildren
		);

		return tableHeader;
	}

	List<TableRow> _buildTableContent(){
		List<TableRow> tableRows = [];

		widget.tbody.forEach((row){
			List<Widget> tdChildren = [];

			row.forEach((td){
				// tdChildren.add(td);
				Widget tableCell = _buildTableCell(td);

				tdChildren.add(tableCell);
			});

			TableRow tableRow = TableRow(
				children: tdChildren
			);

			tableRows.add(tableRow);
		});

		return tableRows;
	}

	Widget _buildTable(BuildContext context){

		
		var tableHeader = _buildTableHeader();
		var tableContent = _buildTableContent();

		tableContent.insert(0, tableHeader);

		return Container(
			child: Table(
				// border: TableBorder.all(
				// 	// color: Colors.grey.withOpacity(0.2),
				// 	color: Colors.transparent,
				// 	width: 2.0,
				// ),
				border: TableBorder(
					// top: BorderSide(
					// 	color: widget.borderColor
					// ),
					bottom: BorderSide(
						width: widget.borderWidth,
						color: widget.borderColor
					),
					right: BorderSide(
						width: widget.borderWidth,
						color: widget.borderColor
					),
				),
				children: tableContent
			),
		);
	
	}

	@override
	Widget build(BuildContext context) => _buildTable(context);

}
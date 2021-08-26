

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/model/dashboard/expense_dashboard.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:provider/provider.dart';

class SearchExpenseDashboard extends StatefulWidget {
  final DashBoardType dashBoardType;
  const SearchExpenseDashboard({Key? key, required this.dashBoardType}) : super(key: key);

  @override
  _SearchExpenseDashboardState createState() => _SearchExpenseDashboardState();
}

class _SearchExpenseDashboardState extends State<SearchExpenseDashboard> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late List<Tab> _tabList;

  @override
  void initState() {
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);

    if(widget.dashBoardType == DashBoardType.Expenditure) {
      _tabList = [
        Tab(text: '${i18.dashboard.ALL}'),
        Tab(text: '${i18.dashboard.PAID}'),
        Tab(text: '${i18.dashboard.PENDING}')
      ];

      dashBoardProvider.fetchExpenseDashBoardDetails(context);
    }else{
      _tabList = [
        Tab(text: '${i18.dashboard.ALL}'),
        Tab(text: '${i18.dashboard.RESIDENTIAL}'),
        Tab(text: '${i18.dashboard.COMMERCIAL}')
      ];
    }
    _tabController = new TabController(vsync: this, length: _tabList.length);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);
    return  StreamBuilder(
        stream: dashBoardProvider.streamController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data is String){
              return CommonWidgets.buildEmptyMessage(snapshot.data, context);
            }
            return _buildView(snapshot.data);
          } else if (snapshot.hasError) {
            return Notifiers.networkErrorPage(context, () => {});
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loaders.CircularLoader();
              case ConnectionState.active:
                return Loaders.CircularLoader();
              default:
                return Container();
            }
          }
        });
  }

  Widget _buildView(ExpenseDashboard expenseDashboard) {
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);

    return Column(
        children: [
          ListLabelText(widget.dashBoardType == DashBoardType.collections ?  i18.dashboard.SEARCH_CONSUMER_RECORDS : i18.dashboard.SEARCH_EXPENSE_BILL),
          BuildTextField(
            '',
            dashBoardProvider.searchController,
            inputBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            prefixIcon: Icon(Icons.search_sharp),
            placeHolder: i18.dashboard.SEARCH_BY_BILL_OR_VENDOR,
            onChange: dashBoardProvider.onSearch,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ButtonsTabBar(
                    controller: _tabController,
                    backgroundColor: Colors.white,
                    unselectedBackgroundColor: Color.fromRGBO(244, 119, 56, 0.12),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    buttonMargin: EdgeInsets.symmetric(horizontal: 5),
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(
                        color: Theme.of(context).primaryColor, fontWeight: FontWeight.w400),
                    radius: 25,
                    tabs: _tabList.map((e) => e).toList(),
                  ),
                ),
                Expanded(
                  child: Consumer<DashBoardProvider>(
                    builder : (_ , dashBoardProvider, child) => TabBarView(
                        controller: _tabController,
                        children: List.generate(_tabList.length, (index) => BillsTable(headerList: dashBoardProvider.expenseHeaderList,
                        tableData: dashBoardProvider.getExpenseData(index),
                        ))
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
    );
  }

}
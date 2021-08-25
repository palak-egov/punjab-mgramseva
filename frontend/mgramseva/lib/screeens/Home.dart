import 'package:flutter/material.dart';
import 'package:mgramseva/providers/home_provider.dart';
import 'package:mgramseva/screeens/HomeCard.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/footer.dart';
import 'package:mgramseva/widgets/help.dart';
import 'package:provider/provider.dart';

import 'HomeWalkThrough/HomeWalkThroughContainer.dart';
import 'HomeWalkThrough/HomeWalkThroughList.dart';
import 'customAppbar.dart';

class Home extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    afterViewBuild();
  }

  afterViewBuild() {
    Provider.of<HomeProvider>(context, listen: false)
      ..setwalkthrough(HomeWalkThrough().homeWalkThrough.map((e) {
        e.key = GlobalKey();
        return e;
      }).toList());
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: Column(children: [
          Align(
              alignment: Alignment.centerRight,
              child: Help(
                callBack: () => showGeneralDialog(
                  barrierLabel: "Label",
                  barrierDismissible: false,
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionDuration: Duration(milliseconds: 700),
                  context: context,
                  pageBuilder: (context, anim1, anim2) {
                    return HomeWalkThroughContainer((index) =>
                        homeProvider.incrementindex(index,
                            homeProvider.homeWalkthrougList[index + 1].key));
                  },
                  transitionBuilder: (context, anim1, anim2, child) {
                    return SlideTransition(
                      position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                          .animate(anim1),
                      child: child,
                    );
                  },
                ),walkThroughKey: Constants.HOME_KEY,
              )),
          Expanded(child: HomeCard()),
          Footer()
        ]));
  }
}

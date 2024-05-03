import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/states.dart';
import '../../layout/cubit/cubit.dart';
import '../../model/followers_model.dart';

import '../../shared/components/follow_item.dart';

class  FollowersScreen extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  const FollowersScreen(this.snapshot, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            List<FollowModel> model = [];
            for (var element in snapshot.data.docs) {
              model.add(FollowModel.fromJson(element.data()));
            }
            return buildFollowScreen(model: model,context: context);
          }
      ),
    );
  }
}

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import '../../layout/app_cubit/cubit.dart';
import '../../model/followers_model.dart';
import 'components.dart';

Widget buildFollowScreen({
  @required List<FollowModel> model,
  @required context,
}) => ConditionalBuilder(
  condition: model.isNotEmpty,
  fallback: (context) => Container(),
  builder: (context) =>
      ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                        model[index].image,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      model[index].name,
                      style:  TextStyle(
                          height: 1.4,
                          color: AppCubit.get(context).isDark?Colors.white:Colors.black
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => divider(),
          itemCount: model.length
      ),
);

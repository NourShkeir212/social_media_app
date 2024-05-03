import 'package:flutter/material.dart';



Widget NoPostFound (BuildContext context,{bool isSearch,String text})=>Center(
  child:  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 150,
        child: Image.asset(
          'assets/image/no_post.png' ,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(height: 10.0,),
      Text(
          isSearch? text :'Sorry..! No post found',
        style: Theme.of(context).textTheme.bodyText1,
      ),
  ]
      )
  );

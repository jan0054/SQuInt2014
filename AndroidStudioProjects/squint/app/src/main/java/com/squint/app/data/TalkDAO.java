package com.squint.app.data;

import java.util.ArrayList;
import java.util.List;

import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class TalkDAO {

	public static final String 	TAG 						= TalkDAO.class.getSimpleName();
	public static final String 	ACTION_LOAD_DATA		 	= "action.load.data.talk";
	public static final String 	DATA						= "data.talk";
	// Column Name
	public static String		NAME						= "name";
	public static String		DESCRIPTION					= "description";
	public static String		START_TIME					= "start_time";
	// Pointers
	public static String		AUTHOR						= "author";    	// "first_name" of author
	public static String		LOCATION					= "location"; 	// "name" of location
	public static String		ABSTRACT					= "abstract";
	public static String		SESSION						= "session";

	public static String		POSTEDBY					= "posted_by";	// (ParseObject - person)
	public static String		CREATEDAT					= "createdAt";	// Date
	public static String		UPDATEDAT					= "updatedAt";	// Date
	
	private Context				mContext;
	private ParseObject			mUser;
	private List<ParseObject>	mData;
	
	
	public TalkDAO(Context context) {
		mContext = context;
		mData = new ArrayList<ParseObject>();
		query(null);
	}
	
	public TalkDAO(Context context, ParseObject object) {
		mContext = context;
		mUser = object;
		mData = new ArrayList<ParseObject>();
		query(mUser);
	}

	
	private void query(ParseObject object) {
		ParseQuery<ParseObject> query = ParseQuery.getQuery(_PARAMS.TABLE_TALK);
		query.orderByAscending(START_TIME);
		//query.setLimit(ITEM_LIMIT);
		if (object != null) query.whereEqualTo(AUTHOR, object);
		query.include(AUTHOR);
		query.include(LOCATION);
		query.include(SESSION);
		query.include(ABSTRACT);
		query.findInBackground(new FindCallback<ParseObject>() {
		     public void done(List<ParseObject> objects, ParseException e) {
		         if (e == null) {
		             onReceived(objects);
		             
		         } else {
		        	 Log.d(TAG, "Error Data: " + e.getMessage());
		             onFailed(_ERROR.PARSE_ERROR.ERROR_GET_CAREER);
		         }
		     }
		});		
	}
	
	public void refresh() {
		query(mUser);
	}
	
	public List<ParseObject> getData() {
		return mData;
	}
		
	// Send intent as callback for finished tasks
	private void onReceived(List<ParseObject> objects) {		
		if (objects == null) return;
		else {
			Log.d(TAG, "Size: " + objects.size());
			mData = objects;
			Intent intent = new Intent(ACTION_LOAD_DATA);
			if (objects.size() > 0) intent.putExtra(DATA, mData.get(0).getObjectId());
			mContext.sendBroadcast(intent);			
		}	
	}
	
	private void onFailed(_ERROR.PARSE_ERROR error) {
		Log.d(TAG, "Error: " + error.getMessage());
	}
}

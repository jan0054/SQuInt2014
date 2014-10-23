package com.squint.app.adapter;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import com.parse.ParseObject;
import com.squint.app.R;
import com.squint.app.TalkDetailsActivity;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class TalkAdapter extends BaseAdapter {

	public static final String		TAG = TalkAdapter.class.getSimpleName();	
	private Context 				context;
	private final LayoutInflater 	inflater;
	private SimpleDateFormat 		sdf;
	private List<ParseObject>	 	data;

	private static class ViewHolder {
		  //public ImageView image;
		  public TextView name;
		  public TextView description;
		  public TextView author_name;
		  public TextView location_name;
		  public TextView start_time;
	}

	public TalkAdapter(Context context, List<ParseObject> data) {
		this.context = context;
		inflater = (LayoutInflater) this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		this.data = data;
		sdf = new SimpleDateFormat("MM-dd hh:mm a", Locale.getDefault());
		Log.d(TAG, "FEED SIZE: " + Integer.toString(data.size()));
	}

	@Override
	public int getCount() {
		return data.size();
	}
	
	@Override
	public ParseObject getItem(int position) {
		return data.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@SuppressLint("InflateParams")
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder;		
		if (convertView == null) {
			convertView = inflater.inflate(R.layout.item_talk, null);
			holder = new ViewHolder();
			holder.name = (TextView) convertView.findViewById(R.id.name);
			holder.description = (TextView) convertView.findViewById(R.id.description);
			holder.author_name = (TextView) convertView.findViewById(R.id.author_name);
			holder.location_name = (TextView) convertView.findViewById(R.id.location_name);
			holder.start_time = (TextView) convertView.findViewById(R.id.start_time);

		} else holder = (ViewHolder) convertView.getTag();
		
		ParseObject item = data.get(position);
		holder.name.setText(getName(item));
		holder.author_name.setText(getAuthor(item));
		holder.description.setText(getDescription(item));
		holder.location_name.setText(getLocationName(item));
		holder.start_time.setText(getStartTime(item));		
		convertView.setTag(holder);
		holder.name.setTag(item);
		
		convertView.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				ViewHolder h = (ViewHolder)v.getTag();				
				ParseObject item = (ParseObject)h.name.getTag();			
				Intent intent = new Intent(TalkDetailsActivity.ACTION_SELECT);
				intent.putExtra(TalkDetailsActivity.EXTRA_TALK_ID, item.getObjectId());
				intent.putExtra(TalkDetailsActivity.EXTRA_TALK_NAME, getName(item));
				intent.putExtra(TalkDetailsActivity.EXTRA_TALK_AUTHOR, getAuthor(item));
				intent.putExtra(TalkDetailsActivity.EXTRA_TALK_AUTHOR_ID, getAuthorId(item));
				intent.putExtra(TalkDetailsActivity.EXTRA_TALK_START_TIME, getStartTime(item));
				intent.putExtra(TalkDetailsActivity.EXTRA_TALK_DESCRIPTION, getDescription(item));
				intent.putExtra(TalkDetailsActivity.EXTRA_TALK_LOCATION_NAME, getLocationName(item));
				intent.putExtra(TalkDetailsActivity.EXTRA_TALK_ABSTRACT_ID, getAbstractId(item));				
				intent.putExtra(TalkDetailsActivity.EXTRA_TALK_ABSTRACT_CONTENT, getAbstractContent(item));				
				intent.putExtra(TalkDetailsActivity.EXTRA_TALK_ABSTRACT_PDF, getAbstractPdf(item));				
				
				context.sendBroadcast(intent);						
			}
		});
		
		return convertView;
	}
	
	public void update(List<ParseObject> feeds) {
		if (data == null) data = new ArrayList<ParseObject>();
		else data.clear();
	    data.addAll(feeds);
	    notifyDataSetChanged();
		Log.d(TAG, "Update: " + feeds.size());
	}
	
	
	private String getName(ParseObject object) {
		return object.getString("name");		
	}
	
	private String getAuthor(ParseObject object) {
		ParseObject author = object.getParseObject("author");
		return (author == null) ? context.getString(R.string.unknown) : author.getString("last_name") + ", " + author.getString("first_name");
	}
	
	private String getAuthorId(ParseObject object) {
		ParseObject author = object.getParseObject("author");
		return (author == null) ? context.getString(R.string.unknown) : author.getObjectId();
	}
	
	
	private String getDescription(ParseObject object) {
		return object.getString("description");		
	}
	
	private String getLocationName(ParseObject object) {
		return object.getParseObject("location").getString("name");		
	}
	
	private String getStartTime(ParseObject object) {
		return sdf.format(object.getDate("start_time"));		
	}

	private String getAbstractId(ParseObject object) {
		return object.getParseObject("abstract").getObjectId();		
	}

	private String getAbstractPdf(ParseObject object) {
		return object.getParseObject("abstract").getParseFile("pdf").getUrl();		
	}
	
	private String getAbstractContent(ParseObject object) {
		return object.getParseObject("abstract").getString("content");		
	}
	
}

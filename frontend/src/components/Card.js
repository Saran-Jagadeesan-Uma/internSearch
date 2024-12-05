const Card = ({ key, company, position, deadline }) => {
    return (
    <>
      <div className="job-card" key={key}>
          <h2 className="company-name">{company}</h2>
          <p className="job-position">{position}</p>
          <p className="job-deadline">Deadline: {deadline}</p>
          <button className="view-button">View</button>
        </div>
    </>
  );
};
export default Card;
